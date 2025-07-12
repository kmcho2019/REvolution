module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= 2'b11; // Count starts from 3
        end
        else if (count > 2'b00) begin
            count <= count - 2'b01;
        end
        else begin
            count <= 2'b00;
        end
    end

    assign shift_ena = (count > 2'b00);

endmodule