module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] byte1, byte2, byte3;
reg idle, byte1_state, byte2_state, done_state;

// Initialize state to idle on reset
always @(posedge clk) begin
    if (reset) begin
        idle <= 1'b1;
        byte1_state <= 1'b0;
        byte2_state <= 1'b0;
        done_state <= 1'b0;
        out_bytes <= 24'b0;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        // State machine logic
        if (idle) begin
            if (in[3] == 1'b1) begin
                byte1 <= in;
                idle <= 1'b0;
                byte1_state <= 1'b1;
            end
        end else if (byte1_state) begin
            byte2 <= in;
            byte1_state <= 1'b0;
            byte2_state <= 1'b1;
        end else if (byte2_state) begin
            byte3 <= in;
            byte2_state <= 1'b0;
            done_state <= 1'b1;
        end else if (done_state) begin
            done_state <= 1'b0;
            idle <= 1'b1;
        end
    end
end

// Assign out_bytes and done
always @(posedge clk) begin
    if (done_state) begin
        out_bytes <= {byte1, byte2, byte3};
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule