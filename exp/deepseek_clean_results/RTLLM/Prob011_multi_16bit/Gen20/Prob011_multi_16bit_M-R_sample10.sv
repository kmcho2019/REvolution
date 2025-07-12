module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;
    reg [4:0] count;  // Need 5 bits to count to 16
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    
    // Combinational next state logic
    wire next_state;
    assign next_state = (!rst_n) ? IDLE :
                       (state == IDLE) ? (start ? BUSY : IDLE) :
                       (state == BUSY) ? ((count == 16) ? IDLE : BUSY) : IDLE;

    // Shift mask rotates left each cycle
    wire [15:0] shift_mask;
    assign shift_mask = (count == 0) ? 16'h0001 : {shift_mask[14:0], 1'b0};

    // Current shifted value of b
    wire [31:0] shifted_b;
    assign shifted_b = {16'b0, breg} << count;

    // Done flag generation
    assign done = (state == BUSY) && (count == 16);
    assign yout = done ? accumulator : 32'd0;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 5'd0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        accumulator <= 32'd0;
                    end
                end
                
                BUSY: begin
                    if (count < 16) begin
                        if (areg & shift_mask) begin
                            accumulator <= accumulator + shifted_b;
                        end
                        count <= count + 1;
                    end else begin
                        count <= 5'd0;
                    end
                end
            endcase
        end
    end

endmodule