module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Concatenate present state and input to form address
    wire [3:0] addr = {y, x};

    reg [3:0] next_state_and_z; // [3:1] = next state bits, [0] = output z

    // Define FSM next state and output z based on present state y and input x
    always @(*) begin
        case(addr)
            4'b0000: next_state_and_z = 4'b0000; // y=000, x=0 -> next_state=000, z=0
            4'b0001: next_state_and_z = 4'b0010; // y=000, x=1 -> next_state=001, z=0

            4'b0010: next_state_and_z = 4'b0010; // y=001, x=0 -> next_state=001, z=0
            4'b0011: next_state_and_z = 4'b1000; // y=001, x=1 -> next_state=100, z=0

            4'b0100: next_state_and_z = 4'b0100; // y=010, x=0 -> next_state=010, z=0
            4'b0101: next_state_and_z = 4'b0010; // y=010, x=1 -> next_state=001, z=0

            4'b0110: next_state_and_z = 4'b0011; // y=011, x=0 -> next_state=001, z=1
            4'b0111: next_state_and_z = 4'b0101; // y=011, x=1 -> next_state=010, z=1

            4'b1000: next_state_and_z = 4'b0111; // y=100, x=0 -> next_state=011, z=1
            4'b1001: next_state_and_z = 4'b1001; // y=100, x=1 -> next_state=100, z=1

            default: next_state_and_z = 4'b0000; // For all other states (101,110,111) default
        endcase
    end

    // Outputs from lookup value
    wire [2:0] next_state = next_state_and_z[3:1];
    wire       z_int      = next_state_and_z[0];

    // Output z depends only on present state; here from lookup table as per problem statement
    assign z = z_int;

    // Y0 is bit 0 of next_state (the LSB)
    assign Y0 = next_state[0];

endmodule