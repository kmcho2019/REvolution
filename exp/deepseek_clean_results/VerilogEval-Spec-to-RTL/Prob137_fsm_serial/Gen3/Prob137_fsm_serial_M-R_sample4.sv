module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    wire done_wire;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'b0;
        end else if (state == RECEIVE) begin
            bit_count <= bit_count + 1;
        end else begin
            bit_count <= 3'b0;
        end
    end

    // Data shift register
    always @(posedge clk) begin
        if (state == RECEIVE) begin
            data_shift <= {in, data_shift[7:1]}; // LSB first
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // Default to stay in current state
        case (1'b1) // Synthesis will optimize this case statement
            state[0]: // IDLE
                if (!in) next_state = RECEIVE;
            state[1]: // RECEIVE
                if (bit_count == 3'b111) next_state = STOP;
            state[2]: // STOP
                next_state = in ? IDLE : ERROR;
            state[3]: // ERROR
                if (in) next_state = IDLE;
        endcase
    end

    // Output logic
    assign done_wire = (state == STOP) & in;
    assign done = done_wire;

endmodule