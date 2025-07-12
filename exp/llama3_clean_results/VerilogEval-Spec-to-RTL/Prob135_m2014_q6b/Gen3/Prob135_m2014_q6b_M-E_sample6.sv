module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    reg [2:0] states [6]; // Define the states
    reg [2:0] next_states [6]; // Define the next states
    integer i;

    // Initialize the states and next states
    initial begin
        states[0] = 3'b000;
        states[1] = 3'b001;
        states[2] = 3'b010;
        states[3] = 3'b011;
        states[4] = 3'b100;
        states[5] = 3'b101;

        // Define the next states based on the input w
        next_states[0] = w ? 3'b000 : 3'b001;
        next_states[1] = w ? 3'b001 : 3'b010;
        next_states[2] = w ? 3'b011 : 3'b010;
        next_states[3] = w ? 3'b000 : 3'b011;
        next_states[4] = w ? 3'b011 : 3'b100;
        next_states[5] = w ? 3'b011 : 3'b101;
    end

    // Find the next state of y[1] based on the current state and input w
    always @(*) begin
        for (i = 0; i < 6; i++) begin
            if (y == states[i]) begin
                Y1 = next_states[i][1]; // Assign the next state of y[1]
                break;
            end
        end
    end
endmodule