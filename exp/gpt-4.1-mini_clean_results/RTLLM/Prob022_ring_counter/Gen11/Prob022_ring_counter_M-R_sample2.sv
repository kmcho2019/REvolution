module ring_counter (
    input  clk,
    input  reset,
    output reg [7:0] out
);

    wire [7:0] next_out;

    // Combinational logic for next state: cyclic left rotate
    assign next_out = {out[6:0], out[7]};

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001; // Initialize with LSB high
        end else begin
            out <= next_out;
        end
    end

endmodule