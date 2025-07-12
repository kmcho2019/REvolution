module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// Define enumerated states
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE_STATE
} state, next_state;

// Define registers
reg [3:0] seq_reg;
reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [1:0] bit_counter;

// Combinational logic for next state
always_comb begin
    case (state)
        IDLE: begin
            if ({seq_reg[2:0], data} == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (bit_counter < 4) begin
                next_state = SHIFT;
            end else begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (counter > 0) begin
                next_state = COUNT;
            end else begin
                next_state = DONE_STATE;
            end
        end
        DONE_STATE: begin
            if (ack == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = DONE_STATE;
            end
        end
    endcase
end

// Sequential logic for state machine
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        seq_reg <= 0;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        bit_counter <= 0;
    end else begin
        case (state)
            IDLE: begin
                seq_reg <= {seq_reg[2:0], data};
            end
            SHIFT: begin
                delay_reg <= {data, delay_reg[3:1]};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4) begin
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                end
            end
            COUNT: begin
                counter <= counter - 1;
                if (counter % 1000 == 0 && counter != 0) begin
                    remaining_time <= remaining_time - 1;
                end
            end
            DONE_STATE: begin
                // Do nothing
            end
        endcase
        state <= next_state;
    end
end

// Output handling
assign count = (state == COUNT)? remaining_time : 4'b0;
assign counting = (state == COUNT);
assign done = (state == DONE_STATE);

endmodule