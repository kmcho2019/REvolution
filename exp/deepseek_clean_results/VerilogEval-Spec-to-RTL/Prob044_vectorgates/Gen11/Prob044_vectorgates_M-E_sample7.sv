module TopModule (
    input [2:0] a,
    input [2:0] b,
    output reg [2:0] out_or_bitwise,
    output reg out_or_logical,
    output reg [5:0] out_not
);

    // Shared inversion logic
    wire [2:0] not_a, not_b;
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : not_gates
            assign not_a[i] = ~a[i];
            assign not_b[i] = ~b[i];
        end
    endgenerate

    // Bitwise OR (parallel)
    always @(*) begin
        out_or_bitwise = a | b;
    end

    // Logical OR (reduction)
    always @(*) begin
        out_or_logical = |(a | b);
    end

    // Concatenated NOT with shared logic
    always @(*) begin
        out_not = {not_b, not_a};
    end

    // Alternative implementation showing the bit-sliced approach concept
    /*
    reg [1:0] phase;
    reg [2:0] temp_not;

    always @(posedge clk) begin
        case (phase)
            0: begin
                temp_not <= ~a;
                phase <= 1;
            end
            1: begin
                out_not <= {~b, temp_not};
                phase <= 0;
            end
        endcase
    end
    */
endmodule