module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Define the LUT for next state logic
    reg [1:0] next_state_lut [0:3];
    initial begin
        next_state_lut[0] = {in ? 2'b01 : 2'b00}; // A
        next_state_lut[1] = {in ? 2'b01 : 2'b10}; // B
        next_state_lut[2] = {in ? 2'b11 : 2'b00}; // C
        next_state_lut[3] = {in ? 2'b01 : 2'b10}; // D
    end

    // Define the LUT for output logic
    reg [0:0] out_lut [0:3];
    initial begin
        out_lut[0] = {1'b0}; // A
        out_lut[1] = {1'b0}; // B
        out_lut[2] = {1'b0}; // C
        out_lut[3] = {1'b1}; // D
    end

    // Look up the next state and output values
    always @(*) begin
        if (in) begin
            case (state)
                2'b00: next_state = 2'b01;
                2'b01: next_state = 2'b01;
                2'b10: next_state = 2'b11;
                2'b11: next_state = 2'b01;
            endcase
        end else begin
            case (state)
                2'b00: next_state = 2'b00;
                2'b01: next_state = 2'b10;
                2'b10: next_state = 2'b00;
                2'b11: next_state = 2'b10;
            endcase
        end

        case (state)
            2'b00: out = 1'b0;
            2'b01: out = 1'b0;
            2'b10: out = 1'b0;
            2'b11: out = 1'b1;
        endcase
    end

endmodule