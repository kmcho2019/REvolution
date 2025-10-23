module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
localparam [1:0] RED    = 2'b00;
localparam [1:0] YELLOW = 2'b01;
localparam [1:0] GREEN  = 2'b10;

// Timing parameters
localparam [7:0] RED_TIME    = 8'd10;
localparam [7:0] YELLOW_TIME = 8'd5;
localparam [7:0] GREEN_TIME  = 8'd60;
localparam [7:0] REQ_TIME    = 8'd10;

reg [1:0] state;
reg [7:0] cnt;

// State and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        cnt <= cnt - 1'b1;
        
        case (state)
            RED: if (cnt == 0) begin
                state <= GREEN;
                cnt <= GREEN_TIME;
            end
            
            YELLOW: if (cnt == 0) begin
                state <= RED;
                cnt <= RED_TIME;
            end
            
            GREEN: begin
                if (pass_request && cnt > REQ_TIME)
                    cnt <= REQ_TIME;
                else if (cnt == 0) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
            end
        endcase
    end
end

// Direct combinatorial outputs
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

endmodule