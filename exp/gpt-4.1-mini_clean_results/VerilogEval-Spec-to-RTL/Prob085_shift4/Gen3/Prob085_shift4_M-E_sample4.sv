module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Internal signals for mux select
wire [3:0] shift_val;
wire [3:0] load_val;

// Shift right: MSB gets 0, others shift right
assign shift_val = {1'b0, q[3:1]};
assign load_val = data;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;  // asynchronous reset
    end else begin
        // Priority: load > ena > hold
        if (load) begin
            q <= load_val;
        end else if (ena) begin
            q <= shift_val;
        end else begin
            q <= q;
        end
    end
end

endmodule