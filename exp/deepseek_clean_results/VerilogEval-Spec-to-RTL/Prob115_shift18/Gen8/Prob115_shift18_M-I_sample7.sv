module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
reg [63:0] next_q;
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire shift_amount = amount[0] ? 3'd7 : 3'd0; // 8 or 1 bits

// Optimized shift logic with enable gating
always @(*) begin
    if (load) begin
        next_q = data;
    end
    else if (do_shift) begin
        if (shift_right) begin
            // Arithmetic right shift with sign extension
            next_q = $signed(q) >>> (shift_amount + 1);
        end
        else begin
            // Left shift
            next_q = q << (shift_amount + 1);
        end
    end
    else begin
        next_q = q;
    end
end

// Sequential update
always @(posedge clk) begin
    q <= next_q;
end

endmodule