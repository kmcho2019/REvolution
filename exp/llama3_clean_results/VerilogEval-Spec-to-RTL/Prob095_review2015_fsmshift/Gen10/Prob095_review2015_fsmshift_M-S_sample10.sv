module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;
        end else if (state == 2'b01) begin
            if (state == 2'b01) begin
                state <= 2'b10;
            end else if (state == 2'b10) begin
                state <= 2'b11;
            end else if (state == 2'b11) begin
                state <= 2'b00;
            end
        end
    end

    assign shift_ena = (state == 2'b01 || state == 2'b10 || state == 2'b11);

endmodule