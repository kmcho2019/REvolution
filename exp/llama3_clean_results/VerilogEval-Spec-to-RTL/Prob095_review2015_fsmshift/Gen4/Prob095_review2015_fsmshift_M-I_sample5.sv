module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 2'd3; // Set count to 3 for 4 cycles
        end
        else if (count > 0) begin
            count <= count - 1'd1; // Decrement count
        end
    end

    always_comb begin
        shift_ena = (count > 0) ? 1'b1 : 1'b0; // Enable shift_ena when count is greater than 0
    end

endmodule