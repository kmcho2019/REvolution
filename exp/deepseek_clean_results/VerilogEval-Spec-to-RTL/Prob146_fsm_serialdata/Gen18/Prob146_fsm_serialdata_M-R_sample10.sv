module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot state encoding (better timing)
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg bit_count_done;

    // Combinational shift register
    wire [7:0] next_shift = {in, shift_reg[7:1]};

    // Registered bit_count comparison
    always @(posedge clk) begin
        if (reset) begin
            bit_count_done <= 0;
        end else begin
            bit_count_done <= (bit_count == 3'd7);
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            
            if (state == RECEIVE) begin
                shift_reg <= next_shift;
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 0;
            end
        end
    end

    // Next state logic (simplified by removing ERROR state)
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 0) ? RECEIVE : IDLE;
            RECEIVE: next_state = bit_count_done ? STOP : RECEIVE;
            STOP:    next_state = (in == 1) ? IDLE : IDLE; // Wait for stop bit but no ERROR state
            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational)
    assign done = (state == STOP) & (in == 1);
    always @(*) begin
        if (state == STOP)
            out_byte = shift_reg;
        else
            out_byte = 8'bx; // Don't care when not in STOP
    end

endmodule