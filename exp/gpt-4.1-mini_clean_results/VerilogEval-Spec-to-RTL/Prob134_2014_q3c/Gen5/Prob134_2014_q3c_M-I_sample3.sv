module TopModule (
    input        clk,
    input        x,
    output       Y0,
    output       z
);
    // One-hot encoding for 5 states: S0=00001, S1=00010, S2=00100, S3=01000, S4=10000
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] state, next_state;

    // One-hot to binary encoding for Y (next state)
    function [2:0] oh_to_bin;
        input [4:0] oh;
        begin
            case (oh)
                S0: oh_to_bin = 3'b000;
                S1: oh_to_bin = 3'b001;
                S2: oh_to_bin = 3'b010;
                S3: oh_to_bin = 3'b011;
                S4: oh_to_bin = 3'b100;
                default: oh_to_bin = 3'b000;
            endcase
        end
    endfunction

    // State register update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (x == 1'b0) ? S0 : S1;
            S1: next_state = (x == 1'b0) ? S1 : S4;
            S2: next_state = (x == 1'b0) ? S2 : S1;
            S3: next_state = (x == 1'b0) ? S1 : S2;
            S4: next_state = (x == 1'b0) ? S3 : S4;
            default: next_state = S0;
        endcase
    end

    // Output Y0 is LSB of the binary encoded next state
    wire [2:0] next_state_bin = oh_to_bin(next_state);
    assign Y0 = next_state_bin[0];

    // Output z depends on current state: z=1 for states 011 and 100 (S3 and S4)
    assign z = (state == S3) || (state == S4);

    // Initialize state at reset is omitted as no reset input given
endmodule