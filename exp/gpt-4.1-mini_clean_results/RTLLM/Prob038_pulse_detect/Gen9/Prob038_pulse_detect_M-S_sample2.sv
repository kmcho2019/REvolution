module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam S0 = 2'b00; // waiting for 0 (start)
    localparam S1 = 2'b01; // got 0, waiting for 1
    localparam S2 = 2'b10; // got 1 after 0, waiting for 0

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                if (data_in == 1'b0)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (data_in == 1'b1)
                    next_state = S2;
                else if (data_in == 1'b0)
                    next_state = S1; // keep waiting for 1
                else
                    next_state = S0; // safety fallback
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S0; // pulse complete
                else if (data_in == 1'b1)
                    next_state = S2; // keep waiting for 0
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // State and output update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is 1 only when pulse completes: transition from S2 to S0
            if (state == S2 && next_state == S0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule