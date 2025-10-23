module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM using binary encoding
logic [1:0] state;  // 0: IDLE, 1: COUNT, 2: DONE
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0;  // IDLE
        byte_count <= 0;
    end
    else begin
        case(state)
            0: begin  // IDLE
                if(in[3]) begin
                    state <= 1;  // COUNT
                    byte_count <= 1;
                end
            end
            1: begin  // COUNT
                if(in[3]) begin
                    byte_count <= 1;  // Reset byte count if new message starts
                end
                else begin
                    byte_count <= byte_count + 1;
                end
                if(byte_count == 3) begin
                    state <= 2;  // DONE
                end
            end
            2: begin  // DONE
                state <= 0;  // IDLE
                byte_count <= 0;  // Reset byte count
            end
        endcase
    end
end

assign done = (state == 2);

endmodule