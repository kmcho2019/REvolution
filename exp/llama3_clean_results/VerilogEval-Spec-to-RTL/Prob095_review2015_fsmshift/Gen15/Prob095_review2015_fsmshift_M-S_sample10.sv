module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic state;
    logic [1:0] counter;

    // Initialize state and counter
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 1'b1;
            counter <= 4;
        end else begin
            if (state) begin
                counter <= counter - 1;
                if (counter == 0) begin
                    state <= 1'b0;
                end
            end
        end
    end

    // Assert shift_ena when in state
    assign shift_ena = state;

endmodule