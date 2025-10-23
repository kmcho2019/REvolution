module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    // Compute shifted and counted values combinationally
    wire [3:0] shift_val = {q[2:0], data}; // MSB-first shift inserting data at LSB
    wire [3:0] count_val = q - 1;

    // Combined enable signal to reduce toggling
    wire ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (ena) begin
            if (shift_ena)
                q <= shift_val;
            else // implicitly count_ena only if shift_ena is 0 due to priority
                q <= count_val;
        end
    end

endmodule