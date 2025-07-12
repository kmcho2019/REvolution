module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE,
        INIT,
        PP1,
        PP2,
        PP3,
        PP4,
        DONE
    } state_t;
    
    reg [2:0] state;
    reg [2:0] cycle_count;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] accumulated;
    
    // Precompute all possible partial products (combinational)
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = {multiplicand[14:0], 1'b0};
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -pp_2A;
    
    // Booth encoder outputs (registered)
    reg [15:0] selected_pp;
    reg [1:0] booth_bits;
    reg prev_lsb;
    
    // Booth encoding logic
    always @(posedge clk) begin
        if (state == INIT) begin
            booth_bits <= multiplier[1:0];
            prev_lsb <= 1'b0;
        end else if (state inside {PP1, PP2, PP3, PP4}) begin
            booth_bits <= multiplier[2*cycle_count+1:2*cycle_count];
            prev_lsb <= booth_bits[0];
        end
    end
    
    // Partial product selection
    always @* begin
        case ({booth_bits, prev_lsb})
            3'b000, 3'b111: selected_pp = pp_0;
            3'b001, 3'b010: selected_pp = pp_A;
            3'b011:         selected_pp = pp_2A;
            3'b100:         selected_pp = pp_neg2A;
            3'b101, 3'b110: selected_pp = pp_negA;
            default:        selected_pp = pp_0;
        endcase
    end
    
    // Shifter for proper alignment
    wire [15:0] shifted_pp = selected_pp << (2*cycle_count);
    
    // Main state machine and datapath
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            rdy <= 1'b0;
            cycle_count <= 0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            accumulated <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= INIT;
                    rdy <= 1'b0;
                end
                
                INIT: begin
                    state <= PP1;
                    cycle_count <= 0;
                    accumulated <= 16'b0;
                end
                
                PP1, PP2, PP3: begin
                    accumulated <= accumulated + shifted_pp;
                    multiplier <= multiplier >> 2;
                    cycle_count <= cycle_count + 1;
                    state <= state + 1;
                end
                
                PP4: begin
                    p <= accumulated + shifted_pp;
                    state <= DONE;
                end
                
                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
    
    // Early completion detection (optional optimization)
    wire early_done = (state inside {PP2, PP3, PP4}) && 
                     (multiplier >> (2*cycle_count) == 0);
    
    always @(posedge clk) begin
        if (early_done && state != DONE) begin
            p <= accumulated + shifted_pp;
            state <= DONE;
        end
    end

endmodule