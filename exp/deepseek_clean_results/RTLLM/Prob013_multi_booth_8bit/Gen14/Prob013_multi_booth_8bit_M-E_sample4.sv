module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam PROCESSING = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] counter;
    reg [1:0] booth_bits;
    reg prev_bit;

    // Partial product generation
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = multiplicand << 1;
    wire [15:0] pp_neg2A = -(multiplicand << 1);
    
    // Booth encoder
    wire [1:0] booth_sel;
    assign booth_sel = {multiplier[1:0], prev_bit};

    // Partial product selection
    reg [15:0] selected_pp;
    always @(*) begin
        case (booth_sel)
            3'b000, 3'b111: selected_pp = pp_0;
            3'b001, 3'b010: selected_pp = pp_A;
            3'b011: selected_pp = pp_2A;
            3'b100: selected_pp = pp_neg2A;
            3'b101, 3'b110: selected_pp = -pp_A;
            default: selected_pp = pp_0;
        endcase
    end

    // Wallace tree reduction (simplified for clarity)
    wire [15:0] sum, carry;
    assign {carry, sum} = p + selected_pp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            counter <= 5'b0;
            prev_bit <= 1'b0;
            state <= IDLE;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= PROCESSING;
                    rdy <= 1'b0;
                end
                
                PROCESSING: begin
                    // Update product with carry-save result
                    p <= sum + (carry << 1);
                    
                    // Shift multiplicand and multiplier
                    multiplicand <= multiplicand << 2;
                    multiplier <= multiplier >> 2;
                    prev_bit <= multiplier[1];
                    
                    // Check for completion
                    if (counter == 5'b00100 || multiplier[7:0] == 8'b0) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end
                    
                    counter <= counter + 1;
                end
                
                DONE: begin
                    // Hold state until reset
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule