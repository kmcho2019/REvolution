module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state;
    logic [1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'b01; // Reset State
            counter <= 4;
        end else begin
            if (state == 2'b01) begin
                if (counter > 1) begin
                    counter <= counter - 1;
                end else begin
                    state <= 2'b00; // Idle State
                    counter <= 0;
                end
            end
        end
    end

    assign shift_ena = (state == 2'b01);

endmodule