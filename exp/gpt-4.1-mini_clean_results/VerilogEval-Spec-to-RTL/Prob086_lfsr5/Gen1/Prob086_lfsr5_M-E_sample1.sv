module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    wire feedback = q[0]; // Feedback bit is output bit (LSB)

    wire next4 = q[4] ^ feedback; // tapped bit 5
    wire next3 = q[3];            // not tapped
    wire next2 = q[2] ^ feedback; // tapped bit 3
    wire next1 = q[1];            // not tapped
    wire next0 = q[4];            // shift in MSB from q[4]

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous reset to 1
        end else begin
            q <= {next4, next3, next2, next1, next0};
        end
    end

endmodule