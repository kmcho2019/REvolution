module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
reg [63:0] shifted_value;
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire [7:0] sign_ext = {8{q[63]}}; // Only used for right shifts

// Shift direction selection
always @(*) begin
    if (shift_right) begin
        // Right shift cases (arithmetic)
        if (amount[0])
            shifted_value = {sign_ext, q[63:8]}; // Shift right by 8
        else
            shifted_value = {q[63], q[63:1]};  // Shift right by 1
    end
    else begin
        // Left shift cases
        if (amount[0])
            shifted_value = {q[55:0], 8'b0};    // Shift left by 8
        else
            shifted_value = {q[62:0], 1'b0};    // Shift left by 1
    end
end

// Clock-gated update logic
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= shifted_value;
    // else retain value (implicit)
end

endmodule