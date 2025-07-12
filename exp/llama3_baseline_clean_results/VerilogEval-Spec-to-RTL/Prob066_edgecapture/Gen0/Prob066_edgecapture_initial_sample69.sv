module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in; // register to store previous input state

always @(posedge clk) begin
    if (reset) begin // if reset is high, clear output and previous input state
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // detect transition from 1 to 0 in the input vector
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin // if transition from 1 to 0 is detected
                out[i] <= 1'b1; // set corresponding output bit to 1
            end
        end
        prev_in <= in; // update previous input state
    end
end

endmodule