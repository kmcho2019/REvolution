module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Shift results computed only when shifting (ena=1 and load=0), else hold q
    reg [63:0] shift_val;

    // Combinational logic to compute shift_val based on amount and current q
    always @(*) begin
        if (load) begin
            // On load, shift_val is irrelevant, assign zero (won't be used)
            shift_val = 64'd0;
        end else if (ena) begin
            // Shift enable active, compute shifted value based on amount
            case (amount)
                2'b00: shift_val = {q[62:0], 1'b0};                 // Shift left by 1
                2'b01: shift_val = {q[55:0], 8'b0};                 // Shift left by 8
                2'b10: shift_val = {msb, q[63:1]};                  // Arithmetic shift right by 1
                2'b11: shift_val = {{8{msb}}, q[63:8]};             // Arithmetic shift right by 8
                default: shift_val = q;                              // Default hold (should not occur)
            endcase
        end else begin
            // Not shifting, keep current value
            shift_val = q;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
        // else q retains its previous value
    end

endmodule