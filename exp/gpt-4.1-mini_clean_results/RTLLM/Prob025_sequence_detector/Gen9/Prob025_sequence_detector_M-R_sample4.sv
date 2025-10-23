module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding using localparam for pure Verilog compatibility
    localparam IDLE = 3'b000;
    localparam S1   = 3'b001; // matched '1'
    localparam S2   = 3'b010; // matched '10'
    localparam S3   = 3'b011; // matched '100'
    localparam S4   = 3'b100; // matched '1001' (final detection)

    reg [2:0] state, next_state;

    // Sequential block: state register update with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational block: next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // enable overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // Output asserted combinationally when current state is the final detection state
    assign sequence_detected = (state == S4);

endmodule