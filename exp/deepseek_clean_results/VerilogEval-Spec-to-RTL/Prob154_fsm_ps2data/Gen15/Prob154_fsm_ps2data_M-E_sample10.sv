module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // Gray-coded state encoding for minimal switching
    localparam [1:0] SEARCH = 2'b00;
    localparam [1:0] CAPTURE1 = 2'b01;
    localparam [1:0] CAPTURE2 = 2'b11;
    localparam [1:0] CAPTURE3 = 2'b10;

    reg [1:0] state;
    reg [23:0] shift_reg;
    reg [1:0] byte_count;
    wire capture_en;

    // Only capture when in CAPTURE states
    assign capture_en = (state != SEARCH);

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 24'bx;
            byte_count <= 2'b00;
        end else begin
            case (state)
                SEARCH: begin
                    if (in[3]) begin
                        state <= CAPTURE1;
                        shift_reg <= {in, 16'b0}; // Initialize with first byte
                        byte_count <= 2'b01;
                    end
                end
                
                CAPTURE1: begin
                    shift_reg <= {shift_reg[23:16], in, 8'b0}; // Shift in second byte
                    byte_count <= byte_count + 1;
                    state <= CAPTURE2;
                end
                
                CAPTURE2: begin
                    shift_reg <= {shift_reg[23:8], in}; // Shift in third byte
                    byte_count <= byte_count + 1;
                    state <= CAPTURE3;
                end
                
                CAPTURE3: begin
                    if (in[3]) begin
                        // Start new message immediately
                        shift_reg <= {in, 16'b0};
                        byte_count <= 2'b01;
                        state <= CAPTURE1;
                    end else begin
                        state <= SEARCH;
                        byte_count <= 2'b00;
                    end
                end
            endcase
        end
    end

    // Combinational done signal when third byte captured
    assign done = (state == CAPTURE3);
    assign out_bytes = (done) ? shift_reg : 24'bx;

endmodule