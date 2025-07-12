module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding using localparam
    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    reg [2:0] state;

    // Combinational function for next state logic
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input data_in;
        begin
            case (curr_state)
                S0: get_next_state = data_in ? S1 : S0;
                S1: get_next_state = data_in ? S2 : S0;
                S2: get_next_state = data_in ? S2 : S3;
                S3: get_next_state = data_in ? S4 : S0;
                S4: get_next_state = S4;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // State and output update on clock edge
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= get_next_state(state, data);
            // Latch output when detected
            if (state == S4)
                start_shifting <= 1'b1;
        end
    end

endmodule