module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
parameter idle      = 2'b00;
parameter s1_red    = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green  = 2'b11;

reg [1:0] state;
reg [5:0] cnt;

// Combined state transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 6'd10;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            
            s1_red: begin
                if (cnt == 6'd1) begin
                    state <= s3_green;
                    cnt <= 6'd60;
                    red <= 1'b0;
                    green <= 1'b1;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            s2_yellow: begin
                if (cnt == 6'd1) begin
                    state <= s1_red;
                    cnt <= 6'd10;
                    yellow <= 1'b0;
                    red <= 1'b1;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            s3_green: begin
                // Handle pedestrian request
                if (pass_request && (cnt > 6'd10)) begin
                    cnt <= 6'd10;
                end
                
                if (cnt == 6'd1) begin
                    state <= s2_yellow;
                    cnt <= 6'd5;
                    green <= 1'b0;
                    yellow <= 1'b1;
                end else begin
                    cnt <= cnt - 6'd1;
                end
            end
            
            default: state <= idle;
        endcase
    end
end

assign clock = cnt;

endmodule