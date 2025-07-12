module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function implementing Rule 110 logic
    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 0;
                3'b110: rule110 = 1;
                3'b101: rule110 = 1;
                3'b100: rule110 = 0;
                3'b011: rule110 = 1;
                3'b010: rule110 = 1;
                3'b001: rule110 = 1;
                3'b000: rule110 = 0;
                default: rule110 = 0;
            endcase
        end
    endfunction

    wire [511:0] next_q;
    wire [513:0] extended_q = {1'b0, q, 1'b0};  // Boundary handling: q[-1]=0, q[512]=0

    // Calculate next state for all bits
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_calc
            assign next_q[i] = rule110(extended_q[i+2], extended_q[i+1], extended_q[i]);
        end
    endgenerate

    // Clocked update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule