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

    // Combinational next state logic
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
                else // remain in S1 while data_in is 0
                    next_state = S1;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S0; // pulse completed
                else // remain in S2 while data_in is 1
                    next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and output generation (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n) begin
            state    <= S0;
            data_out <= 1'b0;
        end else begin
            data_out <= (state == S2 && next_state == S0) ? 1'b1 : 1'b0;
            state    <= next_state;
        end
    end

endmodule