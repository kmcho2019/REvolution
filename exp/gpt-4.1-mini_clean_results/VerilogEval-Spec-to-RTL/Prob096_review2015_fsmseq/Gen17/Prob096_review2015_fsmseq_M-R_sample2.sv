module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // Binary-encoded states
    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched "11"
    localparam S3 = 3'b011; // matched "110"
    localparam S4 = 3'b100; // matched "1101" (final)

    reg [2:0] state;

    // Next state combinational function
    function [2:0] f_next_state;
        input [2:0] curr_state;
        input       data_in;
        begin
            case (curr_state)
                S0: f_next_state = data_in ? S1 : S0;
                S1: f_next_state = data_in ? S2 : S0;
                S2: f_next_state = data_in ? S2 : S3;
                S3: f_next_state = data_in ? S4 : S0;
                S4: f_next_state = S4;
                default: f_next_state = S0;
            endcase
        end
    endfunction

    wire [2:0] next_state = f_next_state(state, data);

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: held high when in detected state
    assign start_shifting = (state == S4);

endmodule