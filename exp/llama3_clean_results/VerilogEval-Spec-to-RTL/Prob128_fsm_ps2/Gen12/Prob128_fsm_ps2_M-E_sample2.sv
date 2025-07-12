module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
enum logic [1:0] {
    Idle = 2'b00,
    Byte1 = 2'b01,
    Byte2 = 2'b10,
    Byte3 = 2'b11
} state, next_state;

// Counter to keep track of the number of bytes received
logic [1:0] byte_count, next_byte_count;

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= Idle;
        byte_count <= 2'b00;
    end
    else begin
        state <= next_state;
        byte_count <= next_byte_count;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    case(state)
        Idle: begin
            if(in[3]) begin
                next_state = Byte1;
                next_byte_count = 2'b01;
            end
        end
        Byte1: begin
            next_byte_count = 2'b10;
            next_state = Byte2;
        end
        Byte2: begin
            next_byte_count = 2'b11;
            next_state = Byte3;
        end
        Byte3: begin
            next_byte_count = 2'b00;
            next_state = Idle;
        end
        default: ;
    endcase
end

// Assert 'done' when a message is fully received
assign done = (state == Byte3);
endmodule