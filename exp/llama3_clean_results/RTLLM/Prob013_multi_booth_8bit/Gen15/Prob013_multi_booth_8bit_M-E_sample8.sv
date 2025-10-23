module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Define the number of processing elements (PEs) in the array
localparam NUM_PES = 8;

// Define the width of each PE's input and output
localparam PE_WIDTH = 16;

// Define the clock frequency for each PE
localparam PE_CLK_FREQ = 100;

// Define the control signals for each PE
reg [NUM_PES-1:0] pe_enable;
reg [NUM_PES-1:0] pe_valid;

// Define the data signals for each PE
reg [NUM_PES-1:0][PE_WIDTH-1:0] pe_data_in;
reg [NUM_PES-1:0][PE_WIDTH-1:0] pe_data_out;

// Define the multiplicand and multiplier registers
reg [15:0] multiplicand;
reg [15:0] multiplier;

// Define the product register
reg [15:0] product;

// Define the ready signal
reg rdy_int;

// Define the clock signal for each PE
reg [NUM_PES-1:0] pe_clk;

// Generate the clock signals for each PE
always @(posedge clk) begin
    for (int i = 0; i < NUM_PES; i++) begin
        pe_clk[i] <= (i == 0)? clk : pe_clk[i-1];
    end
end

// Define the processing element (PE) module
module pe(
    input clk,
    input enable,
    input valid,
    input [PE_WIDTH-1:0] data_in,
    output [PE_WIDTH-1:0] data_out
);

// Define the PE's internal registers
reg [PE_WIDTH-1:0] pe_reg;

// Define the PE's combinational logic
always @(posedge clk) begin
    if (enable) begin
        if (valid) begin
            pe_reg <= data_in;
        end else begin
            pe_reg <= pe_reg << 1;
        end
    end
end

// Define the PE's output
assign data_out = pe_reg;

endmodule

// Instantiate the PEs
pe pe_array [NUM_PES-1:0] (
   .clk(pe_clk),
   .enable(pe_enable),
   .valid(pe_valid),
   .data_in(pe_data_in),
   .data_out(pe_data_out)
);

// Define the control unit
always @(posedge clk) begin
    if (reset) begin
        // Reset the PEs and the product register
        for (int i = 0; i < NUM_PES; i++) begin
            pe_enable[i] <= 0;
            pe_valid[i] <= 0;
            pe_data_in[i] <= 0;
        end
        product <= 0;
        rdy_int <= 0;
    end else begin
        // Start the multiplication process
        if (rdy_int == 0) begin
            // Load the multiplicand and multiplier into the first PE
            multiplicand <= {{8{b[7]}}, b};
            multiplier <= {{8{a[7]}}, a};
            pe_data_in[0] <= multiplicand;
            pe_enable[0] <= 1;
            pe_valid[0] <= 1;
            // Propagate the enable and valid signals to the next PE
            for (int i = 1; i < NUM_PES; i++) begin
                pe_enable[i] <= pe_enable[i-1];
                pe_valid[i] <= pe_valid[i-1];
            end
        end else begin
            // Accumulate the partial products
            for (int i = 0; i < NUM_PES; i++) begin
                if (pe_valid[i]) begin
                    product <= product + pe_data_out[i];
                end
            end
            // Check if the multiplication process is complete
            if (pe_enable[NUM_PES-1]) begin
                rdy_int <= 1;
            end
        end
    end
end

// Define the output
assign p = product;
assign rdy = rdy_int;

endmodule