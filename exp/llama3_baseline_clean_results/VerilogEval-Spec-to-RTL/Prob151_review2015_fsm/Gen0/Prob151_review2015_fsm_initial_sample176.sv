module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE = 2'b11;

reg [1:0] state;
reg [1:0] state_next;

reg [3:0] shift_counter;
reg [3:0] shift_counter_next;

reg [3:0] data_buffer;
reg [3:0] data_buffer_next;

always @(*) begin
    // Default values
    shift_ena = 0;
    counting = 0;
    done = 0;
    
    state_next = state;
    shift_counter_next = shift_counter;
    data_buffer_next = data_buffer;

    case(state)
        IDLE: begin
            if(reset) begin
                state_next = IDLE;
            end
            else if(data_buffer == 4'b1101) begin
                state_next = SHIFT;
                shift_counter_next = 0;
            end
            else if(data) begin
                data_buffer_next = {data_buffer[2:0], data};
            end
            else begin
                data_buffer_next = 0;
            end
        end

        SHIFT: begin
            shift_ena = 1;
            if(shift_counter == 4) begin
                state_next = COUNT;
            end
            else begin
                shift_counter_next = shift_counter + 1;
            end
        end

        COUNT: begin
            counting = 1;
            if(done_counting) begin
                state_next = DONE;
            end
        end

        DONE: begin
            done = 1;
            if(ack) begin
                state_next = IDLE;
            end
        end

        default: state_next = IDLE;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        shift_counter <= 0;
        data_buffer <= 0;
    end
    else begin
        state <= state_next;
        shift_counter <= shift_counter_next;
        data_buffer <= data_buffer_next;
    end
end

endmodule