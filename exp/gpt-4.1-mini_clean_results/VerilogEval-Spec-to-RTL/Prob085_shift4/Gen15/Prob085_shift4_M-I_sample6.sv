module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;
wire       update_enable; // Indicates when q should update

assign update_enable = load | ena;

always @(*) begin
    if (load) begin
        next_q = data;          // Load data directly
    end else if (ena) begin
        next_q = (q >> 1);     // Right shift with zero fill at MSB
    end else begin
        next_q = q;            // Hold current value
    end
end

// Sequential logic with asynchronous reset, update only on load or ena asserted
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else if (update_enable) begin
        q <= next_q;
    end
    // else retain previous q (no unnecessary updates)
end

endmodule