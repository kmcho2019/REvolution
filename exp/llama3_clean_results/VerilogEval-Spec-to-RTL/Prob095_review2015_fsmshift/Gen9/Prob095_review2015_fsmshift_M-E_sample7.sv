module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 2'b00;
        end
        else if (counter < 4) begin
            counter <= counter + 1;
        end
        else begin
            counter <= 4'b0000;
        end
    end

    always_comb begin
        case (counter)
            2'b01, 2'b10, 2'b11: shift_ena = 1'b1;
            default: shift_ena = 1'b0;
        endcase
    end

endmodule