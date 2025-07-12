module TopModule (
    input        clk,    // clock input (not used)
    input        x,
    input  [2:0] y,      // present state
    output       Y0,
    output       z
);

    // Functions implementing minimal Boolean logic for next state bits
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       x_in;
        // Decode present state one-hot for valid states
        wire s000 = (curr_state == 3'b000);
        wire s001 = (curr_state == 3'b001);
        wire s010 = (curr_state == 3'b010);
        wire s011 = (curr_state == 3'b011);
        wire s100 = (curr_state == 3'b100);

        reg ns2, ns1, ns0;
        begin
            // next state bit 2: set if (y=001 & x=1) or (y=100 & x=1)
            ns2 = (s001 & x_in) | (s100 & x_in);

            // next state bit 1: (y=010 & x=0) or (y=011 & x=1) or (y=100 & x=0)
            ns1 = (s010 & ~x_in) | (s011 & x_in) | (s100 & ~x_in);

            // next state bit 0: equals x if y in {000,010}, else ~x for other valid states
            if (s000 || s010)
                ns0 = x_in;
            else if (s001 || s011 || s100)
                ns0 = ~x_in;
            else
                ns0 = 1'b0; // default for invalid states

            get_next_state = {ns2, ns1, ns0};
        end
    endfunction

    // Function to return output z based on present state
    function get_z;
        input [2:0] curr_state;
        begin
            case (curr_state)
                3'b011, 3'b100: get_z = 1'b1;
                default:        get_z = 1'b0;
            endcase
        end
    endfunction

    wire [2:0] next_state;
    assign next_state = get_next_state(y, x);
    assign Y0 = next_state[0];
    assign z = get_z(y);

endmodule