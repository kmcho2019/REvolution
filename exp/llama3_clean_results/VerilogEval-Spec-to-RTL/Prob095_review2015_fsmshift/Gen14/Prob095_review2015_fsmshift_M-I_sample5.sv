module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [1:0] state;
    logic [1:0] counter;

    // State and counter updates
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'b01; // RESET_STATE
            counter <= 4;
        end else begin
            case(state)
                2'b01: begin // RESET_STATE
                    if (counter > 1) begin
                        state <= 2'b01;
                        counter <= counter - 1;
                    end else begin
                        state <= 2'b00; // IDLE_STATE
                        counter <= 0;
                    end
                end
                2'b00: begin // IDLE_STATE
                    state <= 2'b00;
                    counter <= 0;
                end
            endcase
        end
    end

    // Assert shift_ena when counter is greater than 0
    assign shift_ena = (counter > 0);

endmodule