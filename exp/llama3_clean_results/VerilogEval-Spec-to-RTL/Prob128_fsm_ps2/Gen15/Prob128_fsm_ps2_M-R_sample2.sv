module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] state;
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        byte_count <= 2'd0;
        done <= 0;
    end
    else begin
        case(state)
            2'd0: begin // SEARCH
                if(in[3]) begin
                    state <= 2'd1; // Transition to BYTE1
                    byte_count <= 2'd1; // Initialize byte count
                end
            end
            2'd1: begin // BYTE_RECEIVED
                byte_count <= byte_count + 1; // Increment byte count
                if(byte_count == 2'd3) begin
                    state <= 2'd0; // Transition back to SEARCH
                    done <= 1; // Assert 'done'
                end
            end
        endcase
    end
end

// To ensure 'done' is only asserted for one cycle
always_ff @(posedge clk) begin
    if(reset || state != 2'd1 || byte_count != 2'd3) begin
        done <= 0;
    end
end

endmodule