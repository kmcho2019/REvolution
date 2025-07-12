module DFF (
    input wire clk,
    input wire reset,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module DFF_sync_reset_vec #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    // Single always block for the entire vector with synchronous reset for area and power efficiency
    always @(posedge clk) begin
        if (reset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] d,
    output wire [7:0] q
);
    // Instantiate vector DFF with synchronous reset
    // Assign output to wire type by connecting to internal reg in vector DFF module
    wire [7:0] q_int;
    DFF_sync_reset_vec #(.WIDTH(8)) dff_vec_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q_int)
    );

    assign q = q_int;
endmodule