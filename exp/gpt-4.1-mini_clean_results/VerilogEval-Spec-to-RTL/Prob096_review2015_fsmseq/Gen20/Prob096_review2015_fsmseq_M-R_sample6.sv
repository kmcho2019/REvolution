module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // One-hot encoded state bits
    localparam [4:0]
        S0 = 5'b00001,
        S1 = 5'b00010,
        S2 = 5'b00100,
        S3 = 5'b01000,
        S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic as a function for clarity
    function [4:0] f_next_state;
        input [4:0] curr_state;
        input       din;
        begin
            case (curr_state)
                S0: f_next_state = din ? S1 : S0;
                S1: f_next_state = din ? S2 : S0;
                S2: f_next_state = din ? S2 : S3;
                S3: f_next_state = din ? S4 : S0;
                S4: f_next_state = S4; // sticky final state
                default: f_next_state = S0;
            endcase
        end
    endfunction

    // Combinational next state
    always @(*) begin
        next_state = f_next_state(state, data);
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore output: asserted when in sticky detected state S4
    assign start_shifting = (state == S4);

endmodule