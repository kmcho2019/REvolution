module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute Rule 110 next state
    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
            endcase
        end
    endfunction

    // Next state logic
    wire [511:0] next_q;

    // Main cells (1 to 510)
    assign next_q[511:1] = {511{1'b0}};
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : main_cells
            assign next_q[i] = rule110(q[i+1], q[i], q[i-1]);
        end
    endgenerate

    // Boundary cells (0 and 511)
    assign next_q[0] = rule110(q[1], q[0], 1'b0);
    assign next_q[511] = rule110(1'b0, q[511], q[510]);

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule