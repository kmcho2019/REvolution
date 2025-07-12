module sequence_detector(
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot state encoding
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,  // matched '1'
               S2   = 5'b00100,  // matched '10'
               S3   = 5'b01000,  // matched '100'
               S4   = 5'b10000;  // matched '1001' - sequence detected

    reg [4:0] current_state, next_state;

    // Combinational next state logic using assign statements
    wire idle = current_state[0];
    wire s1   = current_state[1];
    wire s2   = current_state[2];
    wire s3   = current_state[3];
    wire s4   = current_state[4];

    // Next state signals
    wire ns_idle, ns_s1, ns_s2, ns_s3, ns_s4;

    assign ns_idle = (idle && (data_in == 1'b0)) || (s3 && (data_in == 1'b0)) || (s4 && (data_in == 1'b0));
    assign ns_s1   = (idle && (data_in == 1'b1)) || (s1 && (data_in == 1'b1)) || (s2 && (data_in == 1'b1)) || (s4 && (data_in == 1'b1));
    assign ns_s2   = (s1 && (data_in == 1'b0));
    assign ns_s3   = (s2 && (data_in == 1'b0));
    assign ns_s4   = (s3 && (data_in == 1'b1));

    // Combine to one-hot next state
    always @(*) begin
        next_state = 5'b0;
        if (ns_idle) next_state = IDLE;
        else if (ns_s1) next_state = S1;
        else if (ns_s2) next_state = S2;
        else if (ns_s3) next_state = S3;
        else if (ns_s4) next_state = S4;
        else next_state = IDLE;  // safe default
    end

    // State flip-flops with synchronous active low reset
    always @(posedge clk) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic - Moore machine: sequence_detected high when in S4
    assign sequence_detected = s4;

endmodule