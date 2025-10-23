module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [2:0] state;
    reg [63:0] processing_chunk;
    reg [63:0] next_chunk;
    reg left_bit, right_bit;
    reg [63:0] temp_result;
    integer i;

    // State machine states
    localparam IDLE = 3'b000;
    localparam LOAD = 3'b001;
    localparam PROCESS = 3'b010;
    localparam SHIFT = 3'b011;
    localparam DONE = 3'b100;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (load) begin
                    q <= data;
                    state <= LOAD;
                end else begin
                    state <= PROCESS;
                    processing_chunk <= q[63:0];
                    left_bit <= 1'b0;  // q[-1] boundary
                    right_bit <= q[64];
                end
            end
            
            LOAD: begin
                state <= IDLE;
            end
            
            PROCESS: begin
                // Process current 64-bit chunk
                temp_result[0] <= left_bit ^ processing_chunk[1];
                for (i = 1; i < 63; i = i + 1) begin
                    temp_result[i] <= processing_chunk[i-1] ^ processing_chunk[i+1];
                end
                temp_result[63] <= processing_chunk[62] ^ right_bit;
                
                state <= SHIFT;
            end
            
            SHIFT: begin
                // Update the corresponding 64 bits in q
                case (state[2:0])
                    3'b000: q[63:0] <= temp_result;
                    3'b001: q[127:64] <= temp_result;
                    3'b010: q[191:128] <= temp_result;
                    3'b011: q[255:192] <= temp_result;
                    3'b100: q[319:256] <= temp_result;
                    3'b101: q[383:320] <= temp_result;
                    3'b110: q[447:384] <= temp_result;
                    3'b111: q[511:448] <= temp_result;
                endcase
                
                // Prepare next chunk
                if (state[2:0] == 3'b111) begin
                    state <= DONE;
                end else begin
                    state[2:0] <= state[2:0] + 1;
                    case (state[2:0] + 1)
                        3'b000: begin
                            processing_chunk <= q[63:0];
                            left_bit <= 1'b0;
                            right_bit <= q[64];
                        end
                        3'b001: begin
                            processing_chunk <= q[127:64];
                            left_bit <= q[63];
                            right_bit <= q[128];
                        end
                        // ... similar cases for other chunks
                        3'b111: begin
                            processing_chunk <= q[511:448];
                            left_bit <= q[447];
                            right_bit <= 1'b0;
                        end
                    endcase
                end
            end
            
            DONE: begin
                state <= IDLE;
            end
        endcase
    end

endmodule