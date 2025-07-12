module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    always @(*) begin
        // Default assignments to handle any unexpected inputs
        next_state = 2'b00;
        out = 1'b0;

        case ({state, in})
            // State A (2'b00)
            {2'b00, 1'b0}: begin next_state = 2'b00; out = 1'b0; end // A -> A on in=0
            {2'b00, 1'b1}: begin next_state = 2'b01; out = 1'b0; end // A -> B on in=1

            // State B (2'b01)
            {2'b01, 1'b0}: begin next_state = 2'b10; out = 1'b0; end // B -> C on in=0
            {2'b01, 1'b1}: begin next_state = 2'b01; out = 1'b0; end // B -> B on in=1

            // State C (2'b10)
            {2'b10, 1'b0}: begin next_state = 2'b00; out = 1'b0; end // C -> A on in=0
            {2'b10, 1'b1}: begin next_state = 2'b11; out = 1'b0; end // C -> D on in=1

            // State D (2'b11)
            {2'b11, 1'b0}: begin next_state = 2'b10; out = 1'b1; end // D -> C on in=0
            {2'b11, 1'b1}: begin next_state = 2'b01; out = 1'b1; end // D -> B on in=1
        endcase
    end

endmodule