module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [3:0] bit_counter; // Counts 0-8 (start bit + 8 data bits)

    // Next state logic (combinational)
    wire [1:0] next_state;
    assign next_state = 
        (reset) ? IDLE :
        (state == IDLE)    ? (in == 1'b0 ? RECEIVE : IDLE) :
        (state == RECEIVE) ? (bit_counter == 4'd8 ? STOP : RECEIVE) :
        (state == STOP)     ? (in == 1'b1 ? IDLE : STOP) : IDLE;

    // Done signal (combinational)
    assign done = (state == STOP) && (in == 1'b1);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_counter <= 4'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_counter <= 4'b0;
                    if (in == 1'b0) begin
                        shift_reg <= 8'b0; // Prepare for new byte
                        bit_counter <= 4'b1; // Start counting
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // Right shift (LSB first)
                    bit_counter <= bit_counter + 1;
                end

                STOP: begin
                    out_byte <= shift_reg;
                    if (in == 1'b1) begin
                        bit_counter <= 4'b0; // Reset counter if valid stop bit
                    end
                end
            endcase
        end
    end

endmodule