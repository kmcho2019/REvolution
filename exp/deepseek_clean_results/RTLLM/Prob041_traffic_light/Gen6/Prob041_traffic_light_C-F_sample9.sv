module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding using localparam
localparam [1:0] S1_RED    = 2'b00;
localparam [1:0] S2_YELLOW = 2'b01;
localparam [1:0] S3_GREEN  = 2'b10;

// Timing parameters
localparam [5:0] RED_TIME    = 6'd10;
localparam [5:0] YELLOW_TIME = 6'd5;
localparam [5:0] GREEN_TIME  = 6'd60;
localparam [5:0] REQ_TIME    = 6'd10;

reg [1:0] state;
reg [5:0] cnt;

// State and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S1_RED;
        cnt <= RED_TIME;
    end else begin
        case (state)
            S1_RED: begin
                if (cnt == 6'd1) begin
                    state <= S3_GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            S2_YELLOW: begin
                if (cnt == 6'd1) begin
                    state <= S1_RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            S3_GREEN: begin
                if (pass_request && (cnt > REQ_TIME)) begin
                    cnt <= REQ_TIME;
                end
                else if (cnt == 6'd1) begin
                    state <= S2_YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1'b1;
                end
            end
            
            default: begin
                state <= S1_RED;
                cnt <= RED_TIME;
            end
        endcase
    end
end

// Direct combinatorial outputs
assign red    = (state == S1_RED);
assign yellow = (state == S2_YELLOW);
assign green  = (state == S3_GREEN);
assign clock  = cnt;

endmodule