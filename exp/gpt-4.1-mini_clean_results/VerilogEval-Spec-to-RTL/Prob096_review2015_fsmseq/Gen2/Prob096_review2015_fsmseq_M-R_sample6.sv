module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

    localparam S0   = 2'b00;
    localparam S1   = 2'b01;
    localparam S11  = 2'b10;
    localparam S110 = 2'b11;

    reg [1:0] state, next_state;
    reg detected;

    // Next state logic as a combinational function
    function [1:0] f_next_state(input [1:0] cur_state, input data_in);
        begin
            case(cur_state)
                S0:   f_next_state = data_in ? S1   : S0;
                S1:   f_next_state = data_in ? S11  : S0;
                S11:  f_next_state = data_in ? S11  : S110;
                S110: f_next_state = data_in ? S1   : S0;
                default: f_next_state = S0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
        end else begin
            state <= next_state;
            // Latch detected when sequence 1101 found: current state S110 and input data=1
            if (state == S110 && data == 1'b1)
                detected <= 1'b1;
            else
                detected <= detected; // retain detection once set
        end
    end

    always @(*) begin
        next_state = f_next_state(state, data);
    end

    // start_shifting is a Moore output driven by detected latch
    assign start_shifting = detected;

endmodule