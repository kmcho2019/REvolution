module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot encoded states: only one bit high at a time
    localparam SEARCH0 = 7'b0000001; // no match yet
    localparam SEARCH1 = 7'b0000010; // matched '1'
    localparam SEARCH2 = 7'b0000100; // matched '11'
    localparam SEARCH3 = 7'b0001000; // matched '110'
    localparam SHIFT   = 7'b0010000; // shifting delay bits (4 cycles)
    localparam COUNT   = 7'b0100000; // counting delay
    localparam DONE    = 7'b1000000; // done, waiting for ack

    reg [6:0] state, next_state;

    reg [1:0] shift_count, next_shift_count;

    // State bits for convenience
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];
    wire s3 = state[3];
    wire sh = state[4];
    wire ct = state[5];
    wire dn = state[6];

    // Next state logic with assign statements
    wire ns0 = reset ? 1'b1 :
               (state == DONE && ack) ? 1'b1 :
               (state == SEARCH0 && data == 1'b0) ? 1'b1 :
               (state == SEARCH1 && data == 1'b0) ? 1'b1 :
               (state == SEARCH3 && data == 1'b0) ? 1'b1 :
               1'b0;

    wire ns1 = (!reset) && (
               (state == SEARCH0 && data == 1'b1) ? 1'b1 :
               (state == SEARCH2 && data == 1'b1) ? 1'b1 :
               1'b0);

    wire ns2 = (!reset) && (
               (state == SEARCH1 && data == 1'b1) ? 1'b1 :
               1'b0);

    wire ns3 = (!reset) && (
               (state == SEARCH2 && data == 1'b0) ? 1'b1 :
               1'b0);

    wire ns_shift = (!reset) && (
                    (state == SEARCH3 && data == 1'b1) ? 1'b1 :
                    (state == SHIFT && shift_count != 2'd3) ? 1'b1 :
                    1'b0);

    wire ns_count = (!reset) && (
                    (state == SHIFT && shift_count == 2'd3) ? 1'b1 :
                    (state == COUNT && !done_counting) ? 1'b1 :
                    1'b0);

    wire ns_done = (!reset) && (
                   (state == COUNT && done_counting) ? 1'b1 :
                   (state == DONE && !ack) ? 1'b1 :
                   1'b0);

    // Combine next_state bits
    assign next_state = {ns_done, ns_count, ns_shift, ns3, ns2, ns1, ns0};

    // Next shift_count logic
    always @(*) begin
        if (state == SHIFT)
            next_shift_count = shift_count + 2'd1;
        else
            next_shift_count = 2'd0;
    end

    // State and shift_count sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
        end
    end

    // Outputs are directly assigned from state bits (Moore outputs)
    assign shift_ena = sh;
    assign counting  = ct;
    assign done      = dn;

endmodule