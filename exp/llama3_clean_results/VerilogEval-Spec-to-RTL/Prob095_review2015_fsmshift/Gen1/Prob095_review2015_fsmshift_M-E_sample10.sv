module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_comb begin
        if (counter > 0) begin
            shift_ena = 1'b1;
        end else begin
            shift_ena = 1'b0;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 4'd4;
        end else if (counter > 0) begin
            counter <= counter - 1'b1;
        end else begin
            counter <= counter;
        end
    end

endmodule