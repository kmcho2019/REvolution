module DFF_Vector #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   reset,
    input  [WIDTH-1:0]      d,
    input  [WIDTH-1:0]      en,     // per-bit enable to control updates
    output reg [WIDTH-1:0]  q
);
    integer i;
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else begin
            for (i = 0; i < WIDTH; i = i + 1) begin
                if (en[i])
                    q[i] <= d[i];
                else
                    q[i] <= q[i];
            end
        end
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    // Currently enable all bits every cycle (matches original spec)
    wire [7:0] en = 8'hFF;

    DFF_Vector #(.WIDTH(8)) dff_vector_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .en(en),
        .q(q)
    );
endmodule