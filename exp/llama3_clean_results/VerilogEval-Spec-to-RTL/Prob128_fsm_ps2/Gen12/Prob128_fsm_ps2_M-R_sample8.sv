module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM as enumerations
enum logic [1:0] {SEARCH, BYTE1, BYTE2} state, next_state;

// Signals for one-hot encoding of states
logic search, byte1, byte2, next_search, next_byte1, next_byte2;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

// Byte count variable
logic [1:0] byte_count, next_byte_count;

assign search = (state == SEARCH);
assign byte1 = (state == BYTE1);
assign byte2 = (state == BYTE2);

always_comb begin
    next_state = state;
    next_msg_received = 0;
    next_byte_count = byte_count;
    next_search = search;
    next_byte1 = byte1;
    next_byte2 = byte2;

    case(state)
        SEARCH: begin
            if(in[3]) begin
                next_state = BYTE1;
                next_byte_count = 1;
                next_search = 0;
                next_byte1 = 1;
                next_byte2 = 0;
            end
            else begin
                next_state = SEARCH;
                next_search = 1;
                next_byte1 = 0;
                next_byte2 = 0;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
            next_byte_count = byte_count + 1;
            next_search = 0;
            next_byte1 = 0;
            next_byte2 = 1;
        end
        BYTE2: begin
            next_state = SEARCH;
            next_byte_count = 0;
            next_search = 1;
            next_byte1 = 0;
            next_byte2 = 0;
            next_msg_received = 1; // Set msg_received flag
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        msg_received <= 0;
        byte_count <= 0;
        search <= 1;
        byte1 <= 0;
        byte2 <= 0;
    end
    else begin
        state <= next_state;
        msg_received <= next_msg_received;
        byte_count <= next_byte_count;
        search <= next_search;
        byte1 <= next_byte1;
        byte2 <= next_byte2;
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule