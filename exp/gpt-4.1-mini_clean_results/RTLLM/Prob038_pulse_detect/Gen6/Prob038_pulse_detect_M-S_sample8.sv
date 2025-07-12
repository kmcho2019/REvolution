module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam S0 = 2'd0; // Waiting for initial 0
    localparam S1 = 2'd1; // Waiting for 1 after initial 0
    localparam S2 = 2'd2; // Waiting for 0 after 1 (end of pulse)

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            S0: begin
                if (data_in == 1'b0)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data_in == 1'b1)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S0;
                else
                    next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

    // Output and state update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only when a pulse ends (on transition S2->S0)
            data_out <= (state == S2 && next_state == S0) ? 1'b1 : 1'b0;
        end
    end

endmodule