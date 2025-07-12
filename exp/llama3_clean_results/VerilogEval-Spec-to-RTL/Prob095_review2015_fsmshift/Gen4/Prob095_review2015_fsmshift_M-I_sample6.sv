module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 3; // Set count to 3 to enable shift_ena for 4 cycles
        end
        else if (count > 0) begin
            count <= count - 1; // Decrement count
        end
        else begin
            count <= 0; // Keep count at 0 when it reaches 0
        end
    end

    assign shift_ena = (count > 0)? 1'b1 : 1'b0;

endmodule