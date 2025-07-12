module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting
reg [1:0] counter; // counter to count 4 clock cycles
reg shift_ena_reg; // register to hold the value of shift_ena

// initialize state and counter
initial begin
    state = 0;
    counter = 0;
end

always @(posedge clk) begin
    if (reset) begin
        // on reset, go to shifting state and reset counter
        state = 1;
        counter = 0;
        shift_ena_reg = 1;
    end else begin
        case (state)
            0: begin // idle state
                // do nothing in idle state
                shift_ena_reg = 0;
            end
            1: begin // shifting state
                // increment counter
                counter = counter + 1;
                shift_ena_reg = 1;
                // if counter reaches 4, go back to idle state
                if (counter == 4) begin
                    state = 0;
                    shift_ena_reg = 0;
                end
            end
            default: begin
                // default state
                state = 0;
                shift_ena_reg = 0;
            end
        endcase
    end
end

// assign output
assign shift_ena = shift_ena_reg;

endmodule